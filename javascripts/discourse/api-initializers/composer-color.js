import { withPluginApi } from "discourse/lib/plugin-api";
import { observes } from "discourse-common/utils/decorators";

export default {
  name: "initialize-composer-color",
  initialize() {
    withPluginApi("0.8.7", (api) => {
      api.modifyClass("controller:composer", {
        pluginId: "colorful-categories",
        @observes("model.categoryId")
        getCategory() {
          let categoryCreateId = this.get("model.categoryId");
          let categoryReplyId = this.get("model.topic.category_id");
          let category;

          if (categoryReplyId) {
            category = this.site.categories.findBy("id", categoryReplyId);
          } else if (categoryCreateId) {
            category = this.site.categories.findBy("id", categoryCreateId);
          }

          if (categoryCreateId || categoryReplyId) {
            document.body.style.setProperty(
              "--composer-category-color",
              "#" + category.color
            );

            document.body.style.setProperty(
              "--composer-category-text-color",
              "#" + category.text_color
            );
          }
        },
      });
    });
  },
};
