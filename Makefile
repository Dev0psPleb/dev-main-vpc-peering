.PHONY: commit pr changelog release

commit:
	git add -A && git commit -m 'VPC Peering' && git push

pr:
	gh pr create --title 'VPC Peering' --body '' && gh pr merge --admin

changelog:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

release:
	semtag final -s minor