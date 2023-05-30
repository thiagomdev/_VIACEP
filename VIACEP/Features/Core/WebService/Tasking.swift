import Foundation

final class Tasking<T: Decodable>: RequestTask {
    let request: Request
    
    private let completion: ((Result<T, Error>) -> Void)?
    private var dataTask: URLSessionDataTask?
    
    init(request: Request, completion: ((Result<T, Error>) -> Void)?) {
        self.request = request
        self.completion = completion
    }
    
    func resumeTask() {
        guard let url = URL(string: request.url) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.request.headers
        request.httpMethod = self.request.method.rawValue
        request.httpBody = self.request.body
        
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if (200...300).contains(httpResponse.statusCode), let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    self?.completion?(.success(decoded))
                } catch let err {
                    self?.completion?(.failure(err))
                }
            }
        })
        
        dataTask?.resume()
    }
    
    func cancelTask() {
        dataTask?.cancel()
    }
}
