# A simple script that dumps only the module (re-)builds

DERIVED_OVERRIDE=testDerivedData

rm -rf $DERIVED_OVERRIDE

echo
echo %%% Building Using Clean DerivedData %%%
echo

xcodebuild -scheme MainFramework build -derivedDataPath testDerivedData | grep -e 'building module '

echo
echo %%% Clean re-build %%%
echo

xcodebuild -scheme MainFramework clean build -derivedDataPath testDerivedData | grep -e 'building module '
