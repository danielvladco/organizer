import 'package:pwa/worker.dart';
import 'package:organizer/pwa/offline_urls.g.dart' as offline;
import 'package:service_worker/worker.dart' as sw;

/// The Progressive Web Application's entry point.
void main() {
  // The Worker handles the low-level code for initialization, fetch API
  // routing and (later) messaging.
  Worker worker = new Worker();

  // The static assets that need to be in the cache for offline mode.
  // By default it uses the automatically generated list from the output of
  // `pub build`. To refresh this list, run `pub run pwa` after each new build.
  worker.offlineUrls = offline.offlineUrls;

  // The above list can be extended with additional URLs:
  //
  // List<String> offlineUrls = new List.from(offline.offlineUrls);
  // offlineUrls.addAll(['https://www.example.org/custom/resource/']);
  // worker.offlineUrls = offlineUrls;

  // Fine-tune the caching and network fetch with dynamic caches and cache
  // strategies on the url-prefixed network routes:
  //
  // DynamicCache cache = new DynamicCache('images');
  // worker.router.registerGetUrl('https://cdn.example.com/', cache.networkFirst);

  // Start the worker.
  worker.run(version: offline.lastModified);

  sw.addEventListener("fetch", (e) {
    //TODO this is not ideal for our usecase https://jakearchibald.com/2014/offline-cookbook/#cache-falling-back-to-network
    e.respondWith(sw.caches.match(e.request).then((res) {
      return res ?? sw.fetch(e.request);
    }));
  });
}
