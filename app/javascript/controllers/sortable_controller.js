import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";
import { put } from "@rails/request.js";

export default class extends Controller {
  static values = {
    group: String,
  };

  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.onEnd.bind(this),
      group: this.groupValue,
    });
  }

  async onEnd(event) {
    const newIndex = event.newIndex;
    const listId = event.item.dataset.listId; // movable
    const taskId = event.item.dataset.taskId; // movable
    const toListId = event.to.dataset.listId; // destination List for Task

    if (taskId && toListId) {
      // Moved Task (taskId) to position (newIndex) in List (toListId)
      await put(`/tasks/${taskId}`, {
        body: JSON.stringify({
          task: { position: newIndex, list_id: toListId },
        }),
      });
    } else if (listId) {
      // Moved List (listId) to position (newIndex) in List (toListId)
      await put(`/lists/${listId}`, {
        body: JSON.stringify({ list: { position: newIndex } }),
      });
    } else {
      console.error("Unknown object moved!");
    }
  }
}
