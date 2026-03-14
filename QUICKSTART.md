## Download the repository

~~~
git clone https://github.com/Bklieger/CodexClaw.git
cd CodexClaw
~~~

## Download Codex and Sign In

Please visit [https://developers.openai.com/codex/cli](https://developers.openai.com/codex/cli) to determine how to complete this step.

## Install the cron job

Note: highly recommended to use a method of authentication that has capped costs, such as a Codex subscription plan, instead of an API key! You are responsible for all costs.

~~~
bash donotmodify/install-codex-homebase-cron.sh
~~~

## Provide Codex with some way of bidirectional communication

I decided to give Codex access to a blank dedicated Discord server for it to communicate regularly. 

You have to share the authentication in a .env file in the CodexClaw directory.

## Finally, add context in SEED.md

In addition, you should provide some initial instructions in a SEED.md file. It is currently empty ready for you to add content. The agent knows to read from it. Mention how you would like the agent to communicate.
