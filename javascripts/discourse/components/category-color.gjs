import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import Category from "discourse/models/category";

function applyCategoryColors(color, textColor) {
  if (color && textColor) {
    document.body.style.setProperty("--category-color", `#${color}`);
    document.body.style.setProperty("--category-text-color", `#${textColor}`);
  }
}

function clearCategoryColors() {
  document.body.style.removeProperty("--category-color");
  document.body.style.removeProperty("--category-text-color");
}

export default class CategoryColor extends Component {
  @service router;

  constructor() {
    super(...arguments);
    this.setCategoryColors();
    this.router.on("routeDidChange", this.setCategoryColors);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.router.off("routeDidChange", this.setCategoryColors);
  }

  get isCategoryRoute() {
    return this.router.currentRoute.params.hasOwnProperty(
      "category_slug_path_with_id"
    );
  }

  get isTopicRoute() {
    console.log(this.router.currentRoute.name);
    return this.router.currentRoute.name.includes("topic.fromParams");
  }

  @action
  setCategoryColors() {
    let category;

    if (this.isCategoryRoute) {
      category = this.router.currentRoute.attributes.category;
    } else if (this.isTopicRoute) {
      const categoryId =
        this.router.currentRoute.parent?.attributes?.category_id;
      category = Category.findById(categoryId);
    }

    if (category) {
      applyCategoryColors(category.color, category.text_color);
    } else {
      clearCategoryColors();
    }
  }
}
