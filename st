#!/bin/execlineb -W

elgetopt i:
elgetpositionals -P1
emptyenv -P

multisubstitute {
	importas HOME HOME
	importas PATH PATH
}
withpath ${HOME}/bin/_mdon/_st:${PATH}
${@}
