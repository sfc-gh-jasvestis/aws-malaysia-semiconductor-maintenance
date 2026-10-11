import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from setup_aws import ident, names


class SetupAwsTests(unittest.TestCase):
    def test_names_are_scoped_to_prefix_account_region(self):
        n = names('my-semiconductor-maintenance', '123456789012', 'us-west-2')
        self.assertEqual(n['bucket'], 'my-semiconductor-maintenance-123456789012-us-west-2')
        self.assertEqual(n['storage_int'], 'MY_SEMICONDUCTOR_MAINTENANCE_S3_INT')
        self.assertEqual(n['iot_rule'], 'my_semiconductor_maintenance_telemetry')

    def test_rejects_unsafe_identifiers(self):
        for bad in ['DB; DROP', 'a-b', '1abc', '']:
            with self.assertRaises(ValueError):
                ident(bad)


if __name__ == '__main__':
    unittest.main()
