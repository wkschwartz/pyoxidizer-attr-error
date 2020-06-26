import sys
from pyox.thinger import f
import django
import xlwings

def main():
    f('123')
    print(django.__version__)
    print(xlwings.__version__)
    f('asdf')
    return 0

if __name__ == '__main__':
    sys.exit(main())
