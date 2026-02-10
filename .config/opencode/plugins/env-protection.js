export const EnvProtection = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "read") return;

      const filePath = output.args?.filePath;
      if (!filePath) return;

      if (filePath.includes(".env") || filePath.includes(".dev")) {
        throw new Error("Do not read .env or .dev files");
      }
    },
  };
};
