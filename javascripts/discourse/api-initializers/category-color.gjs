import { apiInitializer } from "discourse/lib/api";
import CategoryColor from "../components/category-color";
import ComposerCategoryColor from "../components/composer-category-color";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet(
    "above-site-header",
    <template>
      <CategoryColor />
      <ComposerCategoryColor />
    </template>
  );
});
