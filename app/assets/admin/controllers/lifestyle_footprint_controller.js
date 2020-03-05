import { Controller } from 'stimulus';

export default class LifestyleFootprintController extends Controller {
  calculate(event) {
    event.preventDefault();

    this.postForm()
      .then((response) => response.json())
      .then((data) => {
        this.housingResultTarget.innerText = data.housing;
        this.foodResultTarget.innerText = data.food;
        this.carResultTarget.innerText = data.car;
        this.flightsResultTarget.innerText = data.flights;
        this.otherResultTarget.innerText = data.other;
        this.totalTarget.innerText = data.total;
        this.priceTarget.innerText = data.price;
      });
  }

  postForm() {
    return fetch(this.element.action, {
      method: this.element.method,
      body: new FormData(this.element),
      credentials: 'include'
    });
  }
}

LifestyleFootprintController.targets = ['housingResult', 'foodResult', 'carResult', 'flightsResult', 'otherResult', 'total', 'price'];
