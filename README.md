# devops-demo-app

A small Node.js app with a full CI/CD pipeline behind it — every push
gets linted, tested, scanned for vulnerabilities, and deployed to AWS
automatically. No SSH keys, no long-lived AWS credentials, and a
staging environment that has to pass before anything reaches production.

**Live:**
- Staging: http://44.201.220.32:8080
- Production: http://44.201.220.32
 

## How it works

Push to `develop` → lint/test/audit → build the image → scan it with
Trivy → push to a private ECR repo → deploy over AWS Systems Manager
(no SSH) → wait for a health check before calling it done. Only a
reviewed pull request into `main` reaches production, and even then
the deploy itself needs a separate manual approval.


**Run it locally:**
```bash
cd app
npm install
npm test
npm start
```

N:B :- This repo is public on purpose — the IP above is a small demo instance
for this project only, nothing sensitive behind it.
