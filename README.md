# Selenium Grid demo on ROSA

## Step 1 - Install Selenium Grid

```bash
helm repo add docker-selenium https://www.selenium.dev/docker-selenium

# Update charts from docker-selenium repo
helm repo update

# List all versions present in the docker-selenium repo
helm search repo docker-selenium --versions

# Install basic grid latest version
helm install selenium-grid docker-selenium/selenium-grid
```

## Step 2 - Access Selenium Grid

```bash
oc port-forward service/selenium-hub 4444:4444
```

Access the UI on <http://localhost:4444>

Verify that Selenium Grid is ready by checking the status on <http://localhost:4444/wd/hub/status>

## Step 3 - VNC access

```bash
oc port-forward -p service/selenium-chrome-node 6900:6900
```

With your preferred VNC client, open `127.0.0.1:5900` with the default password `secret`.

## Step 4 - Run test locally

```bash
python3 -m venv .venv\n
. .venv/bin/activate\n
pip install selenium
python test_suite.py
```

Set the Selenium Hub endpoint:

```bash
export SELENIUM_HUB_ENDPOINT='http://localhost:4444/wd/hub'
```

When the test runs, you should a browser window opening Chrome and browsing example.com.

In your terminal, you should see the test result:

```bash
----------------------------------------------------------------------
Ran 1 test in 2.435s

OK
```

## Step 5 - Run test in OpenShift (CI/CD)

In the Operator Hub, install the operator named "Red Hat OpenShift Pipelines" provided by Red Hat.

Verify that all Pipelines containers installed by the operator are running in the `openshift-pipelines` namespace.

Build the image. For simplicity, we will build and push an image in Docker Hub.

```bash
docker buildx build --platform linux/amd64 . -t willgarcia/selenium-test
docker push willgarcia/selenium-test
```

Create and run the CI/CI pipeline (Tekton):

```bash
oc apply -f selenium-test-task.yaml
oc apply -f selenium-test-taskrun.yaml
oc apply -f selenium-test-pipeline.yaml
oc apply -f selenium-test-pipelinerun.yaml
```

### Resources

<https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/>
<https://github.com/openshift/pipelines-tutorial>
<https://github.com/SeleniumHQ/docker-selenium/blob/trunk/charts/selenium-grid/README.md>
