import Category from "discourse/models/category";
import { createWidget } from "discourse/widgets/widget";
import { getOwner } from "discourse-common/lib/get-owner";

export default createWidget("category-color", {
  tagName: "",

  html() {
    const router = getOwner(this).lookup("service:router");
    const route = router.currentRoute;

    if (route?.params) {
      let category;
      let categoryColor;
      let categoryTextColor;

      if (route.params.hasOwnProperty("category_slug_path_with_id")) {
        // set category on category pages
        category = Category.findBySlugPathWithID(
          route.params.category_slug_path_with_id
        );
      } else if (
        route.name === "topic.fromParams" ||
        route.name === "topic.fromParamsNear"
      ) {
        // set category on topic pages
        let categoryId = route.parent.attributes.category_id;
        category = Category.findById(categoryId);
      }

      if (category) {
        // setup category color
        categoryTextColor = "#" + category.text_color;
        categoryColor = "#" + category.color;
      }

      if (categoryColor) {
        // set category color as custom CSS property
        document.body.style.setProperty("--category-color", categoryColor);
        document.body.style.setProperty(
          "--category-text-color",
          categoryTextColor
        );
      } else {
        document.body.style.removeProperty("--category-color");
        document.body.style.removeProperty("--category-text-color");
      }
    }
  },
});
