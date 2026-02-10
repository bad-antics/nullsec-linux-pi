import unittest,sys,os
sys.path.insert(0,os.path.join(os.path.dirname(__file__),"..","src"))
from nullsec_linux_pi.core import PiHardener,GPIOManager

class TestPi(unittest.TestCase):
    def test_checks(self):
        h=PiHardener()
        self.assertIn("default_password",h.CHECKS)
        self.assertEqual(h.CHECKS["default_password"]["severity"],"CRITICAL")
    def test_gpio(self):
        g=GPIOManager()
        layout=g.pin_layout()
        self.assertIn(2,layout)
        self.assertEqual(layout[2]["function"],"SDA")

if __name__=="__main__": unittest.main()
