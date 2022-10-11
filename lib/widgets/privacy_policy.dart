import 'package:flutter/material.dart';

class PrivacyPolicyLink extends StatelessWidget {
  const PrivacyPolicyLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "By continuing, you accept our",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
          ),
          child: const Text(
            "Privacy Policy",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              alignment: Alignment.topLeft,
              child: const Text(
                "       Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "In convallis enim eros, sit amet sagittis justo posuere ut. "
                "Fusce ac dapibus tortor, a molestie mi. Proin sed sapien "
                "eleifend, faucibus ipsum eu, tempus nunc. Fusce iaculis sit "
                "amet lacus ut imperdiet. Integer ac sem a libero mattis "
                "sollicitudin. Integer ac metus nisl. Pellentesque sit amet "
                "malesuada mi, sed suscipit est. Praesent lorem sapien, "
                "cursus vel sagittis eget, aliquet maximus ipsum. Ut aliquam "
                "elementum augue. Donec non facilisis arcu. Vestibulum varius "
                "justo magna, vel venenatis elit pharetra non.In sit amet "
                "hendrerit ligula. Fusce et elit nec odio ullamcorper rhoncus. "
                "Ut felis ipsum, volutpat at maximus vitae, posuere vel justo.\n\n"
                "       Fusce quis accumsan elit. Sed quis luctus ex, in molestie "
                "nisl. Ut orci turpis, hendrerit convallis justo nec, venenatis "
                "aliquet neque. Mauris blandit ipsum quis arcu congue vehicula. "
                "Ut ac mi dictum, placerat nisl et, condimentum velit. Fusce "
                "quis vulputate lacus. Vivamus auctor posuere porttitor. Cras "
                "consectetur quam sit amet neque blandit mattis. Cras efficitur "
                "et neque eleifend molestie. Etiam pharetra magna id commodo "
                "elementum. Aliquam eget nulla ut erat aliquet varius. Morbi "
                "feugiat, magna sit amet facilisis posuere, massa lacus "
                "fermentum nibh, ut aliquam odio ipsum sit amet magna."
                "       Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "In convallis enim eros, sit amet sagittis justo posuere ut. "
                "Fusce ac dapibus tortor, a molestie mi. Proin sed sapien "
                "eleifend, faucibus ipsum eu, tempus nunc. Fusce iaculis sit "
                "amet lacus ut imperdiet. Integer ac sem a libero mattis "
                "sollicitudin. Integer ac metus nisl. Pellentesque sit amet "
                "malesuada mi, sed suscipit est. Praesent lorem sapien, "
                "cursus vel sagittis eget, aliquet maximus ipsum. Ut aliquam "
                "elementum augue. Donec non facilisis arcu. Vestibulum varius "
                "justo magna, vel venenatis elit pharetra non.In sit amet "
                "hendrerit ligula. Fusce et elit nec odio ullamcorper rhoncus. "
                "Ut felis ipsum, volutpat at maximus vitae, posuere vel justo.\n\n"
                "       Fusce quis accumsan elit. Sed quis luctus ex, in molestie "
                "nisl. Ut orci turpis, hendrerit convallis justo nec, venenatis "
                "aliquet neque. Mauris blandit ipsum quis arcu congue vehicula. "
                "Ut ac mi dictum, placerat nisl et, condimentum velit. Fusce "
                "quis vulputate lacus. Vivamus auctor posuere porttitor. Cras "
                "consectetur quam sit amet neque blandit mattis. Cras efficitur "
                "et neque eleifend molestie. Etiam pharetra magna id commodo "
                "elementum. Aliquam eget nulla ut erat aliquet varius. Morbi "
                "feugiat, magna sit amet facilisis posuere, massa lacus "
                "fermentum nibh, ut aliquam odio ipsum sit amet magna.",
                style: TextStyle(fontSize: 16),
              )),
        ),
      ),
    );
  }
}
