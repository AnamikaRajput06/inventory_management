import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.updateAllPrices();

    this.element
      .querySelector('#invoice_discount')
      .addEventListener('input', () => {
        this.updateAllPrices();
      });
  }

  addItem(event) {
    event.preventDefault();

    let template = document.querySelector('#invoice-item-template');

    if (!template) {
      console.error('Template not found!');
      return;
    }

    let newId = new Date().getTime();
    let newFields = template.innerHTML.replace(/NEW_RECORD/g, newId);

    document
      .querySelector('#invoice-items')
      .insertAdjacentHTML('beforeend', newFields);
  }

  removeItem(event) {
    event.preventDefault();
    event.target.closest('[data-nested-form]').remove();
    this.updateAllPrices();
  }

  updatePrice(event) {
    const row = event.target.closest('.nested-fields');
    const select = row.querySelector('.product-select');
    const priceField = row.querySelector('.item-price');
    const quantityField = row.querySelector('.quantity-input');
    const totalField = row.querySelector('.item-total');
    const prices = JSON.parse(select.dataset.price);
    const discount =
      parseFloat(this.element.querySelector('#invoice_discount').value) || 0;

    if (select.value) {
      const price = parseFloat(prices[select.value]);
      const quantity = parseFloat(quantityField.value) || 1;
      const lineTotal = price * quantity;
      const discountedTotal = lineTotal * (1 - discount / 100);

      priceField.value = price.toFixed(2);
      totalField.value = discountedTotal.toFixed(2);
    } else {
      priceField.value = '';
      totalField.value = '';
    }

    this.updateGrandTotal();
  }

  updateAllPrices() {
    this.element.querySelectorAll('.product-select').forEach((select) => {
      select.dispatchEvent(new Event('change'));
    });
  }

  updateGrandTotal() {
    const totals = Array.from(this.element.querySelectorAll('.item-total')).map(
      (field) => parseFloat(field.value) || 0
    );

    const grandTotal = totals.reduce((sum, value) => sum + value, 0);
    this.element.querySelector('#invoice_total_amount').value =
      grandTotal.toFixed(2);
  }
}
