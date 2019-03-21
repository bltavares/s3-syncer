use rusoto_core::region::Region;
use rusoto_s3::*;

use actix_web::{dev::Handler, *};
use futures::future::Future;
use std::sync::Arc;

struct Reloader {
    client: Arc<S3Client>,
}

impl Reloader {
    fn list_buckets(
        &self,
    ) -> impl Future<Item = rusoto_s3::ListBucketsOutput, Error = failure::Error> {
        self.client.list_buckets().from_err::<failure::Error>()
    }
}

impl<S> Handler<S> for Reloader {
    type Result = FutureResponse<HttpResponse, Error>;

    fn handle(&self, _: &HttpRequest<S>) -> Self::Result {
        self.list_buckets()
            .from_err()
            .and_then(|response: ListBucketsOutput| {
                let x = dbg!(response.buckets).map(|b| b.len()).unwrap_or(0);
                Ok(HttpResponse::Ok().body(format!("Count: {:?}", x)).into())
            })
            .responder()
    }
}

fn main() {
    server::new(|| {
        let client = Arc::new(S3Client::new(Region::default()));
        let reloader = client.clone();

        App::new().resource("/reload", |r| {
            r.method(http::Method::POST)
                .h(Reloader { client: reloader })
        })
    })
    .bind("127.0.0.1:8080")
    .unwrap()
    .run();
}
