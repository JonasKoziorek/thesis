import numpy as np

class Particle:
    def __init__(self, dim, minx, maxx):
        self.position = np.random.uniform(low=minx, high=maxx, size=dim)
        self.velocity = np.random.uniform(low=-0.1, high=0.1, size=dim)
        self.best_position = np.copy(self.position)
        self.best_score = -1

class PSO:
    def __init__(self, n_particles, dim, minx, maxx, epochs, w=0.5, c1=1, c2=2):
        self.n_particles = n_particles
        self.dim = dim
        self.minx = minx
        self.maxx = maxx
        self.epochs = epochs
        self.w = w
        self.c1 = c1
        self.c2 = c2
        self.swarm = [Particle(dim, minx, maxx) for _ in range(n_particles)]

    def optimize(self, function):
        global_best_score = -1
        global_best_position = np.zeros(self.dim)

        for _ in range(self.epochs):
            for particle in self.swarm:
                fitness = function(particle.position)

                if fitness > particle.best_score:
                    particle.best_score = fitness
                    particle.best_position = particle.position

                if fitness > global_best_score:
                    global_best_score = fitness
                    global_best_position = particle.position

            for particle in self.swarm:
                particle.velocity = (self.w * particle.velocity +
                                     self.c1 * np.random.random() * (particle.best_position - particle.position) +
                                     self.c2 * np.random.random() * (global_best_position - particle.position))
                particle.position += particle.velocity

        return global_best_position, global_best_score