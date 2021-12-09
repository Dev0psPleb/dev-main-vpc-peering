.PHONY: commit pr

commit:
	git add -A && git commit -m 'VPC Peering' && git push

pr:
	gh pr create --title 'VPC Peering' --body '' && gh pr merge --admin