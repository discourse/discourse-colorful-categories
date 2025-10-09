import { apiInitializer } from "discourse/lib/api";
import CategoryColor from "../components/category-color";
import ComposerCategoryColor from "../components/composer-category-color";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "above-site-header",
    <template>
      <CategoryColor />
      <ComposerCategoryColor />
    </template>
  );
});
