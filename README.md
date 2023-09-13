# Scan your Solidity files with TestMachine

[TestMachine](https://TestMachine.ai) is a tool for identifying and reporting vulnerabilities on Solidity smart contracts, with the goal of making code more consistent and avoiding bugs. This Github action allows you to automatically invoke the TestMachine-CLI

## Requirements

- Have an account on TestMachine.
- You have a valid API token from TestMachine.
- You have already created a repository in TestMachine and have the repository id
- Make sure you have the compiled smart contract in the repository where you will setup this github action

## Usage

Enable a workflow in the repository that contains your .sol file(s). This is usually declared in the file `.github/workflows/build.yml`. And edit it to look like:

```yaml
on:
  # Trigger analysis when pushing in "main" branch. Change this to another branch if you need to
  push:
    branches:
      - main

name: Scanner Workflow
jobs:
  tmscan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: TestMachine Scan
        uses: testmachine-ai/github-action@main
        with:
          # All arguments are required
          # TM_REPOSITORY_ID: Use an already existing repository id (in this example: 120)
          # TM_SOURCE: The json file (or .zip with many .json files inside) with the compiled contract(s) you want to analyze (in this example: ourContracts.zip)
          TM_REPOSITORY_ID: 120
          TM_SOURCE: ourContracts.zip
        env:
          # All env variables are required
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          TM_TOKEN_KEY: ${{ secrets.TM_TOKEN_KEY }}
      - name: Upload result
        uses: actions/upload-artifact@v3
        with:
          name: result-report
          path: action_work_result_report.pdf
```

### Secrets

- `TM_TOKEN_KEY`: This is the token from TestMachine. You can set a Github action secret in the "Secrets" settings page of your repository.
- `GITHUB_TOKEN`: Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).

## Have question or feedback?

To provide feedback (requesting a feature or reporting a bug) please [Contact us](https://TestMachine.ai)
