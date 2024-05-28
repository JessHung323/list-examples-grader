CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
cp student-submission/*.java grading-area #copy student's submission to grading area
cp TestListExamples.java grading-area #copy tester file to grading area
javac -cp $CPATH grading-area/*.java #compile the submission and tester

if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

echo "Compilation successful."

# Run JUnit tests and capture the output
TEST_CLASS="TestListExamples"
TEST_OUTPUT=$(java -cp "$CPATH:grading-area" org.junit.runner.JUnitCore "$TEST_CLASS")

# Output the raw test results for debugging
echo "Raw JUnit test output:"
echo "$TEST_OUTPUT"

# Extract relevant information from the test output
TEST_SUMMARY=$(echo "$TEST_OUTPUT" | grep -E "OK|Failures")

# Initialize variables for total tests, passed tests, and failed tests
NUM_TESTS=0
NUM_FAILURES=0

if [[ "$TEST_SUMMARY" == *"OK"* ]]; then
  # If all tests passed, extract the total number of tests from the OK line
  NUM_TESTS=$(echo "$TEST_SUMMARY" | awk -F '[()]' '{print $2}' | awk '{print $1}')
  NUM_PASSED=$NUM_TESTS
else
  # If there are failures, extract the number of failed and total tests
  NUM_FAILURES=$(echo "$TEST_SUMMARY" | grep -oE "[0-9]+" | head -n 1)
  NUM_TESTS=$(echo "$TEST_SUMMARY" | grep -oE "[0-9]+" | tail -n 1)

  # If NUM_FAILURES or NUM_TESTS is empty, set them to a default value
  if [[ -z "$NUM_FAILURES" ]]; then
    NUM_FAILURES=0
  fi

  if [[ -z "$NUM_TESTS" ]]; then
    NUM_TESTS=0
  fi

  # Calculate the number of tests that passed
  NUM_PASSED=$((NUM_TESTS - NUM_FAILURES))
fi

# Display the results
echo "Total tests run: $NUM_TESTS"
echo "$NUM_PASSED tests passed, $NUM_FAILURES tests failed."