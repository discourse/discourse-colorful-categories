import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "category-color",

  initialize() {
    withPluginApi("0.8.7", (api) => {
      api.decorateWidget("category-color:after", (helper) => {
        helper.widget.appEvents.on("page:changed", () => {
          helper.widget.scheduleRerender();
        });
      });
    });
  },
};
