const DatePicker = {
  mounted() {
    flatpickr(this.el, {
      enableTime: false,
      dateFormat: "F d, Y",
      onChange: this.handleDatePicked.bind(this),
    });
  },

  handleDatePicked(selectedDates, dateStr, instance) {
    // send the dateStr to the LiveView
    this.pushEvent("dates-picked", dateStr);
  }
}

export default DatePicker;