import 'dart:html' as html;
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:success_academy/profile/profile_model.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<QueryDocumentSnapshot>> getSubscriptionsForUser(
    String userId) async {
  final subscriptionsQuery = await db
      .collection('customers')
      .doc(userId)
      .collection('subscriptions')
      .where('status', whereIn: ['trialing', 'active']).get();
  return subscriptionsQuery.docs;
}

Future<List<QueryDocumentSnapshot>> _getProducts() async {
  final productQuery =
      await db.collection('products').where('active', isEqualTo: true).get();
  return productQuery.docs;
}

Future<List<QueryDocumentSnapshot>> _getAllPrices() async {
  final productDocs = await _getProducts();
  final priceDocs = <QueryDocumentSnapshot>[];
  for (final doc in productDocs) {
    final priceQuery = await doc.reference
        .collection('prices')
        .where('active', isEqualTo: true)
        .get();
    priceDocs.addAll(priceQuery.docs);
  }
  return priceDocs;
}

Future<void> startStripeSubscriptionCheckoutSession(
    {required String userId,
    required String profileId,
    required SubscriptionPlan subscriptionPlan,
    required isReferral}) async {
  String? selectedPriceId;
  final priceDocs = await _getAllPrices();
  for (final doc in priceDocs) {
    try {
      if (doc.get('metadata.id') ==
          EnumToString.convertToString(subscriptionPlan)) {
        selectedPriceId = doc.id;
      }
    } on StateError {
      debugPrint('No metadata.id field found for price ${doc.id}');
    }
  }

  final checkoutSessionDoc = await db
      .collection('customers')
      .doc(userId)
      .collection('checkout_sessions')
      .add(
    {
      'price': selectedPriceId,
      'success_url': html.window.location.origin,
      'cancel_url': html.window.location.origin,
      'metadata': {
        'profile_id': profileId,
        'is_referral': isReferral,
      },
    },
  );
  checkoutSessionDoc.snapshots().listen(
    (doc) {
      if (doc.data()!.containsKey('url')) {
        html.window.location.replace(doc.data()!['url']);
      }
    },
  );
}

Future<void> redirectToStripePortal() async {
  HttpsCallable getStripePortalCallable =
      FirebaseFunctions.instanceFor(region: 'us-west2')
          .httpsCallable('ext-firestore-stripe-payments-createPortalLink');
  try {
    final data = await getStripePortalCallable
        .call(<String, dynamic>{'returnUrl': html.window.location.origin});
    html.window.location.assign(data.data['url']);
  } catch (e) {
    // TODO: Collect client error logs to be viewable.
    debugPrint('redirectToStripePortal failed: $e');
    throw HttpException('redirectToStripePortal failed: $e');
  }
}
