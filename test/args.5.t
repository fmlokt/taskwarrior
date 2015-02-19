#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
###############################################################################
#
# Copyright 2006 - 2015, Paul Beckingham, Federico Hernandez.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# http://www.opensource.org/licenses/mit-license.php
#
###############################################################################

import sys
import os
import unittest
# Ensure python finds the local simpletap module
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from basetest import Task, TestCase


class TestStopEnpassant(TestCase):
    def setUp(self):
        """Executed before each test in the class"""
        self.t = Task()
        # No journal log which may contain the words we are looking for
        self.t.config("journal.info", "off")

    def test_start(self):
        """Test 'start' with en-passant changes"""
        self.t(("add", "one"))
        self.t(("1", "start"))
        self.t(("add", "two"))
        self.t(("2", "start"))
        self.t(("add", "three"))
        self.t(("3", "start"))
        self.t(("add", "four"))
        self.t(("4", "start"))
        self.t(("add", "five"))
        self.t(("5", "start"))

        self.t(("1", "stop", "oneanno"))
        code, out, err = self.t(("1", "info"))
        self.assertRegexpMatches(out, "Description +one\n[0-9: -]+ oneanno",
                                 msg="stop enpassant annotation")

        self.t(("2", "stop", "/two/TWO/"))
        code, out, err = self.t(("2", "info"))
        self.assertRegexpMatches(out, "Description +TWO",
                                 msg="stop enpassant modify")

        self.t(("3", "stop", "+threetag"))
        code, out, err = self.t(("3", "info"))
        self.assertRegexpMatches(out, "Tags +threetag",
                                 msg="stop enpassant tag")

        self.t(("4", "stop", "pri:H"))
        code, out, err = self.t(("4", "info"))
        self.assertRegexpMatches(out, "Priority +H",
                                 msg="stop enpassant priority")

        self.t(("5", "stop", "pro:PROJ"))
        code, out, err = self.t(("5", "info"))
        self.assertRegexpMatches(out, "Project +PROJ",
                                 msg="stop enpassant project")


if __name__ == "__main__":
    from simpletap import TAPTestRunner
    unittest.main(testRunner=TAPTestRunner())

# vim: ai sts=4 et sw=4
