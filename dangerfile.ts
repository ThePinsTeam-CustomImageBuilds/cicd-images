import {
    danger,
    warn,
    fail
} from "danger";
import yarn from "danger-plugin-yarn"

if (danger.gitlab.mr.title.includes("WIP:")) {
    fail("WIP prefix is deprecated in GitLab 14 in favor of Draft prefix.")
} else if (danger.gitlab.mr.title.includes("Draft:") && danger.gitlab.mr.work_in_progress == true) {
    warn("Merge request is currently work in progress, test at your own risk!.")
}

// trigger the Yarn plugin for changes
yarn()

const Dangerfile = danger.git.fileMatch("dangerfile.js").edited;
if (Dangerfile) {
  warn(
    "This merge request contains changes to the Dangerfile, please review them as possible before approval and merging."
  );
}
