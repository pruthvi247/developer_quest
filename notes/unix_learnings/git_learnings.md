======================================================
https://www.vogella.com/tutorials/Git/article.html
======================================================
A file in the working tree of a Git repository can have different states. These states are the following:

	> untracked: the file is not tracked by the Git repository. This means that the file never staged nor committed.

	> tracked: committed and not staged

	> staged: staged to be included in the next commit

	> dirty / modified: the file has changed but the change is not staged


> git add - is staged
> commit the staged changes into the Git repository via the git commit command
> After adding the selected files to the staging area, you can commit these files to add them permanently to the Git repository. Committing creates a new persistent snapshot (called commit or commit object) of the staging area in the Git repository. A commit object, like all objects in Git, is immutable.
> git checkout HEAD~1 will actually GO/checkout to that reference/commit
> git reset HEAD~3 will uncommit your last 3 commits — without removing the changes, ie you can see all the changes made in the last 3 commits together, remove anything you don't like or add onto it and then commit them all again.

> git clean -f will remove untracked files
> The staging area is the place to store changes in the working tree before the commit. The staging area contains a snapshot of the changes in the working tree (changed or new files) relevant to create the next commit and stores their mode (file type, executable bit).
> git checkout <branch name> -> switches to another branch

$ git checkout feature
$ git merge master
[source: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging]
> To create a new branch and switch to it at the same time, you can run the git checkout command with the -b switch:
>> git checkout -b iss53
This is shorthand for:

$ git branch iss53
$ git checkout iss53

You can run your tests, make sure the hotfix is what you want, and finally merge the hotfix branch back into your master branch to deploy to production. You do this with the git merge command:

$ git checkout master
$ git merge hotfix

It’s worth noting here that the work you did in your hotfix branch is not contained in the files in your iss53 branch. If you need to pull it in, you can merge your master branch into your iss53 branch by running git merge master, or you can wait to integrate those changes until you decide to pull the iss53 branch back into master later.


> You decide to run git rebase dev from your feature branch to get up-to-date with dev.
However when you run the rebase command, there are some conflicts between the changes you made on feature and the new commits on dev. Thankfully, the rebase process goes through each commit one at a time and so as soon as it notices a conflict on a commit, git will provide a message in the terminal outlining what files need to be resolved. Once you’ve resolved the conflict, you git add your changes to the commit and run git rebase --continue to continue the rebase process. If there are no more conflicts, you will have successfully rebased your feature branch onto dev

> https://medium.com/osedea/git-rebase-powerful-command-507bbac4a234


> git init
> git add . (add files to staging area)
> git commit -m "Initial commit"
> git log
> git show (command to see the changes of a commit)
> git checkout (command to reset a tracked file (a file that was once staged or committed) to its latest staged or commit state. The command removes the changes of the file in the working tree. This command cannot be applied to files which are not yet staged or committed)
> git checkout -b branch_name (creating and switching new branch)
>git remote add upstream git@gitlab.spire2grow.com:core-prototypestagcloud-feedback-engine.git
> git remote -v
> git pull upstream branchname
> -Pushing to the new branch
git push <remote-name> <branch-name> (git push -u origin master)
> git pull command allows you to get the latest changes from another repository for the current branch
> lists all branches including the remote branches
git branch -a
> git branch <name> (creating branch name)
  git checkout -b myFeature dev (creating new branch from old branch, we should be in the dev branch if we want to creat myFeature branch from dev branch)
  git  branch  <branch _name>  <commit id> (creating branch form commit id)
> git branch -m [old_name] [new_name] (re naming branch)
> git branch -d <branch name> (deleting a branch)
> git diff master your_branch (different between branches)
> git show <commit_id> (To see the changes introduced by a commit)
> See the difference between two commits
		# directly between two commits
			git diff HEAD~1 HEAD

		# using commit ranges
			git diff  HEAD~1..HEAD
> The git blame command allows you to see which commit and author modified a file on a per line base.
> git checkout [commit_id]


[source : https://dev.to/nyxtom/top-10-git-commands-everyone-should-know-57e0]


>>>
Tom Holloway 🏕
Aug 21 Updated on Aug 22, 2020 ・8 min read
In this article, we're going to go over my top 10 git commands I use almost every day. If you're new to programming, or just getting familiar with git, then I highly recommend becoming familiar with a few of these commands. There are some great GUIs out there, but nothing beats learning the command line.

git status

git status will display the difference between the index and the current HEAD commit, paths that have differences between the working tree and the index file, and paths in the working tree that are not yet tracked. Docs
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   todo.md
You'll use this one so much that I would recommend creating an alias for it in your ~/.bashrc file with:

alias st='git status'
git add

git add updates the index using the current content found in the working tree, to prepare the content staged for the next commit. It typically adds the current content of existing paths as a whole, but with some options it can also be used to add content with only part of the changes made to the working tree files applied, or remove paths that do not exist in the working tree anymore docs
I frequently use the -p option to stage only parts of a file instead of the entire changeset when I have multiple things I've done in a single commit. It's helpful when you want to split up your work into multiple commits.

git commit

git commit will create a new commit containing the current contents of the index and the given log message describing the changes. The new commit is a direct child of HEAD, usually the tip of the current branch, and the branch is updated to point to it docs
git commit -m 'Message'
If you don't want to open up the built-in editor (aka Vim for me), you can use -m to inline your message. Since I frequently have commit hooks I usually let vim open up to edit my message. Remember to :wqa!

git diff

git diff will show changes between the working tree and the index or a tree, changes between the index and a tree, changes between two trees, changes resulting from a merge, changes between two blob objects, or changes between two files on disk. docs
I frequently will use this one to perform diffs between branches as well. git diff branch1..branch2. You can also take a diff and output it to a file git diff > patch.diff. You can pass that file along and later apply it with git apply patch.diff.

git stash

If you're working on something and you need to store it away temporarily, use git stash. You can use git stash like a clipboard of sorts and even name it with git stash -m name. Later you can apply it with git stash apply stash^name. If you aren't naming your stash you can manipulate what's in the stash with git stash pop, git stash list. doc

git log

git log has loads of options you can use to manipulate what you are looking at. Here are a few I've used that could be helpful doc

git log --graph`: Draw a text-based graphical representation of the commit history on the left hand side of the output. This may cause extra lines to be printed in between commits, in order for the graph history to be drawn properly
git log --format=<format> or git log --pretty=<format>: Pretty-print the contents of the commit logs in a given format, where can be one of oneline, short, medium, full, fuller, reference, email, raw, format: and tformat:. When is none of the above, and has %placeholder in it, it acts as if --pretty=tformat: were given.
git log -c: With this option, diff output for a merge commit shows the differences from each of the parents to the merge result simultaneously instead of showing pairwise diff between a parent and the result one at a time. Furthermore, it lists only files which were modified from all parents.
git push

Updates remote refs using local refs, while sending objects necessary to complete the given refs. doc
git pull

Git pull is actually a combination of two commands in git. git fetch and git merge.

Incorporates changes from a remote repository into the current branch. In its default mode, git pull is shorthand for git fetch followed by git merge FETCH_HEAD.
More precisely, git pull runs git fetch with the given parameters and calls git merge to merge the retrieved branch heads into the current branch. With --rebase, it runs git rebase instead of git merge. doc

git checkout

Switch branch or restore working tree files. Updates files in the working tree to match the version in the index or the specified tree. If no pathspec was given, git checkout will also update HEAD to set the specified branch as the current branch. doc
git checkout -b <branch> is the usual way you will want to checkout a new branch. Otherwise you can also checkout an existing branch with git checkout <branch> provided the branch is available and the tree has been fetched already.

git checkout -f <filename> you can use this to restore the state of a file or a pattern of files; you can also use the added options in the case of unmerged entries such as (--ours or --theirs)

git blame

Git blame is a handy utility for determining what revision and which author is to blame for each line in a file. Many editors have plugins available to display this right into the editor. doc

While there are a number of options, the one I use most is git blame <file> but to be perfectly honest the built in git blame commands in Vim or VS Code are much better suited to navigating on the fly.

Git blame can be helpful to lookup where code was moved, how it got there, and in what specific changesets it occurred.

🎉 BONUS: git reset

Git reset has three primary forms of resetting the state of the working tree. It comes in the form of the flags --soft --hard and --mixed. doc

--soft Does not touch the index file or the working tree at all (but resets the head to , just like all modes do). This leaves all your changed files "Changes to be committed", as git status would put it.
--hard Resets the index and working tree. Any changes to tracked files in the working tree since are discarded.
--mixed Resets the index but not the working tree (i.e., the changed files are preserved but not marked for commit) and reports what has not been updated. This is the default action.
Typically, if I made a mistake in my last commit and I want to undo that change before I go and push to remote I will restage that commit as follows.

git reset --soft HEAD^. This will unstage the last commit I made and keep it in the working changes. I will make my changes and recommit. If you don't want to use this approach and you simply want to make changes on top of an existing commit, you can use git commit --amend to amend on top of the last commit.

🎉 BONUS++: git bisect

If you are having trouble figuring out when a bug was committed and you don't know the exact commit that caused it, then take a look at git bisect.

This command uses a binary search algorithm to find which commit in your project’s history introduced a bug. You use it by first telling it a "bad" commit that is known to contain the bug, and a "good" commit that is known to be before the bug was introduced. Then git bisect picks a commit between those two endpoints and asks you whether the selected commit is "good" or "bad". It continues narrowing down the range until it finds the exact commit that introduced the change. doc
You do this by running through a series of commands:

git bisect start
git bisect bad HEAD (if current HEAD has the bug)
git bisect good v1.0 (commit where everything was good)
git bisect reset (rest the current bisect session)
You can also shorthand the first 3 commands with git bisect start HEAD HEAD~10 (for last 10 commits is where the bug is somewhere).

🎉🎉🎉 Expert Level: git rebase

Be careful with this command, but if you are really looking to make adjustments to your commit history, take a look at git rebase. I've used git rebase when I need to clean up my commit history in my branch before I'm ready to merge. It's really quite useful if you end up having a number of commits that look something like this:


47d07f83 Lint
953b4fcb Fix tests
36da7d28 Lint error
2d85a6ab Fix background colors in tmux to match nova
0227a7f5 Fix window/tab navigation in tmux

Want to get rid of those last 3 commits but they need to be removed/merged/squashed/reordered? Use git rebase -i HEAD~5 where -i will let you look at the revision history and HEAD~5 is approximately 5 commits from the HEAD of the tree. This will drop you into an editor to make changes to those commits. You can even make additional edits to an existing commit in this mode and amend with git commit --amend. Once you're done here, use git rebase --continue.

Side note: it's really easy to mess up the commit history this way so I'd recommend reserving this command for only managing your branch commits at times. If you end up revising the commit history and it includes merged commits then the parent tree might end up being out of sync and that's a mess you don't want to get caught in. Make sure you know what you're doing :)

[source : https://betterprogramming.pub/10-handy-git-stash-commands-to-manage-your-code-efficiently-39ddc3d6f324]

Handy git stash commands: 

> To save your modifications into a stash, type:
$ git stash

> What about the newly created (untracked) files? They remain in the working tree. If you want to stash them as well, add the — all option
$ git stash -all

> List all stashes:
$ git stash list
> Apply the latest stash:
$ git stash apply
> To apply a specific stash, you have to provide the stash ID:
$ git stash apply stash@{0}
> to apply the changes and delete the stash from the stash list
$ git stash pop stash@{0}
>  without providing a specific stash ID, it would delete the topmost stash from the list:
$ git stash pop
> Show changes without applying them
$ git stash show
> To view the content of most recent stash:
$ git stash show -p
>  more useful to see the modifications in a particular stash:
$ git stash show -p stash@{1}
> Create a new branch from stash:
$ git stash branch new_branch stash@{2}
*Note that above command will delete the stash from the list, just like the git stash pop command.
> show modified file name
$ git stash show --name-only
> Apply stashed changes from a particular file:
$ git restore -s stash@{0} -- <filename>
If you want to clean up your stashe:
$ git stash clear
*Note that this operation may be unrecoverable.
> Delete a single stash entry:
$ git stash drop stash@{2}
 ##### Adding more changes to your last commit

> git add <newfile>

>  git commit --amend or git commit --amend --no-edit (Amending a Commit Without Changing Its Message)

> git push -f origin <some_branch>

Just Editing a Commit Message :

> git commit --amend -m "Your new commit message"

#### [Git merge vs Rebase](https://blog.bytebytego.com/i/99358794/git-merge-vs-git-rebase-what-are-the-differences)

**Git Merge**  
This creates a new commit G’ in the main branch. G’ ties the histories of both main and feature branches.  
  
Git merge is **non-destructive**. Neither the main nor the feature branch is changed.  
  
**Git Rebase**  
Git rebase moves the feature branch histories to the head of the main branch. It creates new commits E’, F’, and G’ for each commit in the feature branch.  
  
The benefit of rebase is that it has **linear commit history.**  
  
Rebase can be dangerous if “the golden rule of git rebase” is not followed.

![[Pasted image 20230201122545.png]]



Add all but not few files

```
git add --all -- ':!js-learnings/HTML-CSS-Responsive-Udemy/0-all-design-guidelines.pdf' ':!js-learnings/HTML-CSS-Responsive-Udemy/0-theory-lectures-v2-SMALLER.pdf'
```