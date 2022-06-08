// ignore_for_file: avoid_types_as_parameter_names

import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Plannn {
  final CollectionReference plan =
      FirebaseFirestore.instance.collection('plan');

  Future<void> updatePlan(id, images) {
    return plan
        .doc(id)
        .update({
          'picture': images,
        })
        // ignore: avoid_print
        .then((value) => showToast("devis mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'appareil : $error"));
  }
}
