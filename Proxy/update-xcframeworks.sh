echo "✅ rm -rf Carthage"
rm -rf Carthage

echo "✅ carthage update --platform iOS --use-xcframeworks --no-use-binaries"
carthage update --platform iOS --use-xcframeworks --no-use-binaries

echo "✅ rm -rf Carthage/Checkouts"
rm -rf Carthage/Checkouts

echo "✅ rm Carthage/Build/.*.version"
rm Carthage/Build/.*.version
