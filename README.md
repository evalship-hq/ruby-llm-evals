# LLM evals for Ruby

A Ruby support bot whose AI call is tested on every pull request with [tinyeval](https://tinyeval.com).

## Run it

Clone this repo, or use it as a template. Then:

```sh
bundle install
export ANTHROPIC_API_KEY=sk-ant-...
./tinyeval
```

```
support
  ✓ refund after the window 12.3s
  ✓ missing package 15.6s
  ✓ refund inside the window 14.9s

All 3 evals passed (eval-results.json)
```

## What's here

- `lib/support.rb`: the app. `Support#answer(message)` sends the message to Claude with the system prompt and returns the reply.
- `prompts/support.md`: the system prompt.
- `evals/support.sh`: three test cases, checked with a regex, an LLM judge or both.
- `evals/worker.rb`: starts the app once and answers each test case.
- `tinyeval`: the eval runner, one bash file. `./tinyeval update` replaces it with the latest release.
- `.github/workflows/evals.yml`: runs the evals on every pull request and on pushes to main.

## Use it for your app

1. Replace `Support#answer` with your AI call. Keep the worker, so your app starts once instead of once per test case.
2. Write your own test cases in `evals/`. The check lines, such as `contains`, `matches` and `judge`, are in [tinyeval's README](https://github.com/evalship-hq/tinyeval#writing-evals).
3. In a Rails app, make the worker line in `evals/support.sh` this, and call your own class in `evals/worker.rb`. Rails then boots once per worker instead of once per test case.

   ```bash
   worker bin/rails runner evals/worker.rb
   ```

## In CI

Add `ANTHROPIC_API_KEY` as a repository secret under **Settings** > **Secrets and variables** > **Actions**. tinyeval's judge uses the same key.

The workflow runs each test case 3 times, and a test case passes when at least 2 of the 3 pass. A failing eval fails the job, so you can require it before merging. The workflow uploads `eval-results.json` as the `eval-results` artifact, also when an eval fails.

Without the secret, the workflow skips the evals and prints a notice. Pull requests from forks get no secrets, so their evals skip too.

## Compare pull requests with main

A fresh CI run has no earlier run to compare with. [evalship](https://evalship.com) reads `eval-results.json` as is, compares each pull request with main, tells flaky evals from real drops and comments on the pull request.

## License

MIT. See [LICENSE](LICENSE).
