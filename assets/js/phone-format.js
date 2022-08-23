import { AsYouType } from "libphonenumber-js";

const PhoneFormat = {
  mounted() {
    this.el.addEventListener("input", e => {
      this.el.value = new AsYouType("US").input(this.el.value);
    });
  }
}

export default PhoneFormat; 
