// Fetch the EC2 instance IP address
fetch("http://169.254.169.254/latest/meta-data/public-ipv4")
  .then(response => response.text())
  .then(ip => {
    document.getElementById("ip-address").textContent = ip;
  })
  .catch(() => {
    document.getElementById("ip-address").textContent = "Unable to fetch IP address";
  });