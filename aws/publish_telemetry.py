"""Publish simulated fab tool telemetry to AWS IoT Core (topic my/semiconductor-maintenance/telemetry).

The IoT rule lands each message in S3; Snowpipe loads it into RAW.LIVE_TELEMETRY.
Tool IDs come from RAW.TOOLS (TOOL-0000..TOOL-0023). Values are seeded random.
"""
import argparse
import json
import random
from datetime import datetime, timezone

TOPIC = 'my/semiconductor-maintenance/telemetry'


def build_message(rng, now=None):
    """One synthetic reading: pump vibration (mm/s) and chamber temperature (C)."""
    now = now or datetime.now(timezone.utc)
    alarm = rng.random() < 0.1
    return {'tool_id': f'TOOL-{rng.randint(0, 23):04d}',
            'event_ts': now.strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3],
            'vibration_mm_s': round(rng.gauss(7.8 if alarm else 2.9, 0.8), 2),
            'temperature_c': round(rng.gauss(76 if alarm else 52, 4), 1),
            'status': 'ALARM' if alarm else 'RUNNING'}


def publish_request(message):
    """Keyword arguments for the iot-data Publish call."""
    return {'topic': TOPIC, 'qos': 1, 'payload': json.dumps(message).encode('utf-8')}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--region', default='us-west-2')
    ap.add_argument('--count', type=int, default=40)
    ap.add_argument('--seed', type=int)
    args = ap.parse_args()
    import boto3
    iot = boto3.client('iot', region_name=args.region)
    endpoint = iot.describe_endpoint(endpointType='iot:Data-ATS')['endpointAddress']
    data = boto3.client('iot-data', region_name=args.region, endpoint_url=f'https://{endpoint}')
    rng = random.Random(args.seed)
    for _ in range(args.count):
        data.publish(**publish_request(build_message(rng)))
    print(f'published {args.count} messages to {TOPIC} via {endpoint}')


if __name__ == '__main__':
    main()
