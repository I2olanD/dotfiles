export const NotificationPlugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/PeasantWhat3.ogg`;
      }
      if (event.type === "session.compacted") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/PeasantPissed5.ogg`;
      }
      if (event.type === "session.error") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/HumanPesantMaleDeathA.ogg`;
      }
      if (event.type === "session.idle") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/PeonBuildingComplete1.ogg`;
      }
      if (event.type === "permission.asked") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/PeonWhat3.ogg`;
      }
      if (event.type === "permission.replied") {
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/PeonYes4.ogg`;
      }
    },
  };
};
