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
        const sounds = [
          "PeasantWhat3.ogg",
          "PeasantYesAttack1.ogg",
          "PeasantYes4.ogg",
        ];
        const sound = sounds[Math.floor(Math.random() * sounds.length)];
        await $`ffplay -nodisp -autoexit -loglevel quiet ~/.config/opencode/plugins/sounds/${sound}`;
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
