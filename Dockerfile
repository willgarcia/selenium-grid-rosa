# Base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the test suite file and dependencies
COPY test_suite.py .

# Install necessary dependencies
RUN pip install selenium

# Command to run the test suite
CMD ["python", "test_suite.py"]
