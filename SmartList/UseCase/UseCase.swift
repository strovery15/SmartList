

import Foundation

protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter1
    associatedtype Parameter2
    associatedtype Success
    associatedtype Failure
    
    func execute(_ parameter1: Parameter1,_ parameter2: Parameter2, completion: ((Result<Success, Failure>) -> ())?)
}

final class UseCase<Parameter1, Parameter2, Success, Failure: Error>: UseCaseProtocol {
    
    private let instance: UseCaseInstanceBase<Parameter1, Parameter2, Success, Failure>
    
    init<T: UseCaseProtocol>(_ useCase: T) where T.Parameter1 == Parameter1, T.Parameter2 == Parameter2, T.Success == Success, T.Failure == Failure {
        self.instance = UseCaseInstance<T>(useCase)
    }
    
    func execute(_ parameter1: Parameter1,_ parameter2: Parameter2, completion: ((Result<Success, Failure>) -> ())?) {
        instance.execute(parameter1, parameter2, completion: completion)
    }
}

private extension UseCase {
    
    class UseCaseInstanceBase<Parameter1, Parameter2, Success, Failure: Error> {
        func execute(_ parameter1: Parameter1,_ parameter2: Parameter2, completion: ((Result<Success, Failure>) -> ())?) {
            fatalError()
        }
    }
    
    class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter1, T.Parameter2, T.Success, T.Failure> {
        
        private let useCase: T
        
        init(_ useCase: T) {
            self.useCase = useCase
        }
        
        override func execute(_ parameter1: T.Parameter1,_ parameter2: T.Parameter2, completion: ((Result<T.Success, T.Failure>) -> ())?) {
            useCase.execute(parameter1, parameter2, completion: completion)
        }
    }
}

