(() => {
  const name     = "fixed",
        list     = document.querySelector(".header").classList,
        feature  = document.querySelector(".feature"),
        referral = document.querySelector(".referral");

  let height = feature.scrollHeight;

  if (referral) {
    height += referral.scrollHeight;
  }

  window.addEventListener("scroll", () => {
    if (window.scrollY >= height) {
      list.add(name);
    } else {
      list.remove(name);
    }
  });
})();
