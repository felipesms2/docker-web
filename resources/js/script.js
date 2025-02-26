$(document).ready(function () {
    const form = $('#loginForm');
    const loginButton = $('.btn-primary');
    const passwordField = $('#password');
    const passwordFeedback = $('.password-feedback');

    // Initially disable the login button
    loginButton.prop('disabled', true);

    form.on('submit', function (event) {
      if (!form[0].checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.addClass('was-validated');
    });

    // Email validation regex
    function isValidEmail(email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailRegex.test(email);
    }

    // Password validation regex (at least 8 characters, one uppercase, one number, one special character)
    function isValidPassword(password) {
      const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$/;
      return passwordRegex.test(password);
    }

    function validateForm() {
      const emailField = $('#email');
      const isEmailValid = isValidEmail(emailField.val());
      const isPasswordValid = isValidPassword(passwordField.val());

      if (isEmailValid && isPasswordValid) {
        loginButton.prop('disabled', false); // Enable the login button
      } else {
        loginButton.prop('disabled', true); // Disable the login button
      }
    }

    // Custom email validation
    $('#email').on('input', function() {
      const emailField = $(this);
      const emailValue = emailField.val();
      if (!isValidEmail(emailValue)) {
        emailField[0].setCustomValidity("Please enter a valid email address.");
      } else {
        emailField[0].setCustomValidity(""); // Reset custom validity when valid
      }
      validateForm(); // Call validateForm on input
    });

    // Password validation
    passwordField.on('input', function() {
      const passwordValue = $(this).val();
      const isPasswordValid = isValidPassword(passwordValue);
      if (!isPasswordValid) {
        $(this)[0].setCustomValidity("Password must be at least 8 characters long, contain one uppercase letter, one number, and one special character.");
        passwordFeedback.text("Password must be at least 8 characters long, contain one uppercase letter, one number, and one special character.");
      } else {
        $(this)[0].setCustomValidity(""); // Reset custom validity when valid
        passwordFeedback.text("Password is valid.");
      }
      validateForm(); // Call validateForm on input
    });
  });
