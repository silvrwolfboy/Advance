/// Implements a simple spring acceleration function.
public struct SpringFunction<T>: SimulationFunction where T: VectorConvertible {
    
    /// The target of the spring.
    public var target: T
    
    /// Strength of the spring.
    public var tension: Double
    
    /// How damped the spring is.
    public var damping: Double
    
    /// The minimum Double distance used for settling the spring simulation.
    public var threshold: Double
    
    /// Creates a new `SpringFunction` instance.
    ///
    /// - parameter target: The target of the new instance.
    public init(target: T, tension: Double = 120.0, damping: Double = 12.0, threshold: Double = 0.1) {
        self.target = target
        self.tension = tension
        self.damping = damping
        self.threshold = threshold
    }
    
    /// Calculates acceleration for a given state of the simulation.
    public func acceleration(value: T.VectorType, velocity: T.VectorType) -> T.VectorType {
        let delta = value - target.vector
        let accel = (-tension * delta) - (damping * velocity)
        return accel
    }
    
    public func convergence(value: T.VectorType, velocity: T.VectorType) -> Convergence<T> {
        let min = T.VectorType(repeating: -threshold)
        let max = T.VectorType(repeating: threshold)
        
        if clamp(value: velocity, min: min, max: max) != velocity {
            return .keepRunning
        }
        
        let valueDelta = value - target.vector
        if clamp(value: valueDelta, min: min, max: max) != valueDelta {
            return .keepRunning
        }
        
        return .converge(atValue: target.vector)
    }
    
}
