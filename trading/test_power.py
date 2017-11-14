from Naked.toolshed.shell import execute_js,muterun_js
import sys

response = muterun_js('power_off.js')
if response.exitcode == 0:
    print(response.stdout)
else:
    sys.stderr.write(response.stderr)