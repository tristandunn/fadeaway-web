var Order = {
  initialize: function(options) {
    this.findElements();
    this.bindEventListeners();
    this.focusError();

    if (options) {
      this.setError(options.error);
    }
  },

  create: function(event) {
    if (this.pending) {
      return event.preventDefault();
    }

    if (this.validate()) {
      this.toggle();

      if (this.token && this.token.value.trim() === "") {
        Stripe.createToken(this.parameters(), this.onResponse.bind(this));
      } else {
        return;
      }
    }

    event.preventDefault();
  },

  focusError: function() {
    var element = this.form.getElementsByClassName("field_with_errors")[1];

    if (!element) {
      return;
    }

    var input = element.getElementsByTagName("input")[0];

    if (input) {
      input.focus();
    }
  },

  toggle: function() {
    var button  = this.button,
        pending = this.pending = !this.pending;

    if (pending) {
      button.className += " disabled";
    } else {
      button.className = button.className.replace(/\s*disabled\s*/, "");
    }

    button.innerText = pending ? "Processing..." : "Purchase";
  },

  bindEventListeners: function() {
    this.form.addEventListener("submit", this.create.bind(this), false);
  },

  findElements: function() {
    this.form   = document.getElementById("new_order");
    this.cvc    = document.getElementById("card_cvc");
    this.year   = document.getElementById("card_year");
    this.month  = document.getElementById("card_month");
    this.error  = document.getElementById("error");
    this.token  = document.getElementById("card_token");
    this.number = document.getElementById("card_number");
    this.button = this.form.getElementsByTagName("button")[0];
  },

  onResponse: function(status, response) {
    if (status === 200) {
      this.token.value = response.id;
      this.form.submit();
    } else {
      var field = {
         "cvc"       : this.cvc,
         "number"    : this.number,
         "exp_year"  : this.year,
         "exp_month" : this.month
       }[response.error.param] || this.number;

      this.setError(response.error.message, field);
      this.toggle();
    }
  },

  parameters: function() {
    var year   = this.year.value.trim(),
        prefix = "";

    if (year.length === 2) {
      prefix = (new Date()).getFullYear().toString().substring(0, 2);
    }

    return {
      "cvc"       : this.cvc.value.trim(),
      "number"    : this.number.value.trim(),
      "exp_year"  : prefix + year,
      "exp_month" : this.month.value.trim()
    };
  },

  setError: function(message) {
    if (!this.error) {
      return;
    }

    var element;

    if (message) {
      this.error.innerText = message;
      this.error.style.display = "block";

      var elements = Array.prototype.slice.call(arguments, 1);

      for (var index = 0; index < elements.length; index++) {
        element = elements[index];

        if (index === 0) {
          element.focus();
        }

        element.className += " error";
      }

    } else {
      var elements = [this.number, this.cvc, this.month, this.year];

      for (var index = 0; index < elements.length; index++) {
        element = elements[index];
        element.className = element.className.replace(/(\serror|error\s)/, "");
      }

      this.error.innerText = "";
      this.error.style.display = "none";
    }
  },

  validate: function() {
    if (!this.token || this.token.value.trim() != "") {
      return true;
    }

    var parameters = this.parameters();

    this.setError(null);

    if (!Stripe.validateCardNumber(parameters.number)) {
      this.setError("Your card number is incorrect.", this.number);
    } else if (!Stripe.validateExpiry(parameters.exp_month, parameters.exp_year)) {
      this.setError("Your card's expiration date is invalid.", this.month, this.year);
    } else if (!Stripe.validateCVC(parameters.cvc)) {
      this.setError("Your card's security code is invalid.", this.cvc);
    } else {
      return true;
    }

    return false;
  }
};
