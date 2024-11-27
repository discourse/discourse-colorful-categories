import Component from "@glimmer/component";
import { action } from "@ember/object";
import { addObserver, removeObserver } from "@ember/object/observers";
import { service } from "@ember/service";
import Category from "discourse/models/category";

export default class ComposerCategoryColor extends Component {
  @service composer;
  @service site;
  @service appEvents;

  currentCategory = null;

  constructor() {
    super(...arguments);

    this.appEvents.on("composer:will-open", this.handleComposerOpened);
  }

  willDestroy() {
    super.willDestroy(...arguments);

    this.appEvents.off("composer:will-open", this.handleComposerOpened);
    this.removeCategoryObserver();
  }

  observeCategoryChanges() {
    if (this.composer.model) {
      addObserver(this.composer.model, "categoryId", this, this.updateCategory);
    }
  }

  removeCategoryObserver() {
    if (this.composer.model) {
      removeObserver(
        this.composer.model,
        "categoryId",
        this,
        this.updateCategory
      );
    }
  }

  get categoryId() {
    return this.composer.model?.get("categoryId");
  }

  @action
  handleComposerOpened() {
    this.observeCategoryChanges();
    this.updateCategory();
  }

  @action
  updateCategory() {
    const categoryId = this.categoryId;
    const category = Category.findById(categoryId);

    if (category) {
      this.currentCategory = category;
      document.body.style.setProperty(
        "--composer-category-color",
        `#${category.color}`
      );
      document.body.style.setProperty(
        "--composer-category-text-color",
        `#${category.text_color}`
      );
    } else {
      this.clearCategoryColors();
    }
  }

  @action
  clearCategoryColors() {
    this.currentCategory = null;
    document.body.style.removeProperty("--composer-category-color");
    document.body.style.removeProperty("--composer-category-text-color");
  }

  <template></template>
}
