# Log of our meetings

## 18.9.2023

### Tasks

* select discrete dynamical systems to be studied
* select characteristic attributes of dynamical systems to be studies - eg bifurcations, lyapunov

## 10.2.2023

### Tasks

* generate bifurcation diagram for Logistic map
* generate bifurcation diagram for rulkov map


## 9.10.2023

### Tasks

* investigate hypothesis that intermittency occurc when chaotic behaviour transitions into periodic on bifurcation diagram of maps:
	* (1+ϵ)*x + (1-ϵ)*x^2 (mod 1), where ϵ is in [4.3,4.7], x0=0.5
	* r*cos(pi*x), x0=0.5

	* eg. see the vertical walls that transiton into 1-periodic fixed points and zoom on the transition. See whether intermittency always occurs there.

* write email to authors of Nonlinear Dynamics and ask them about homeomorphism, eg. how they modified original Manneville's map that shows intermittency
* find about motivations behind original Manneville's map, eg. turbulent flow
* produce plots, label them correctly, put equations and plots into thesis
* he mentioned Baker's map - one dimensional with modulo, I should check that out
* next meeting is next week
* investigate reverse/inverse bifurcation


## 16.10.2023

### Tasks

* investigate intermittent area of bifurcation diagrams and their timeseries
* for certain parameter plot take intermittent subset and periodic subset of the graph and show difference in their bifurcation diagrams - depending on the choice of the last n samples bifurcation diagram will be either periodic or chaotic - show how this mistake can occur
* show this on 1d maps and 2d maps - find other 2d map which displays intermittency - dicrete predator prey or other
* read about weak chaos and explain next time
* invent name for this phenomena - chaos suppresion, death of chaos
* see if you can find a way to extend periodic or intermittent subsets of timeseries by changing parameter by small values - try to extend it to being stable for 1000 iterations or longer - try to extend it to being chaotic for 1000 iterations or longer

* see if you can understand the transition from intermittency to stability through examination of timeseries at the breakpoint
* lyapunov exponent - see if the timeseries displaying intermittency exhibits chaos
* Logistic equation for r from -2 to 4
* read about route to chaos, period doubling

### Advice
* be systematic
* save params and plots and give them good description

## 23.10.2023

### Tasks

* I should start writing
* approximate structure of the thesis could be
	1. introduction and motivation
	2. mathematical theory/background for the problem
	3. 1d models, their theory and results of numerical experiments, plots 
	4. 2d models, their theory and results of numerical experiments, plots 
	5. conclusion
* he said I should focus on point 3. and 4.
* I should create big fancy plot for each model which shows timeseries for different parameters, breakpoint, intermittency near breakpoint and difference between bifurcation diagrams in intermittent regions when changing the sample size, shifting of timeseries when moving the param etc.

* next meeting on 6.11.2023

## 6.1.2023

### Tasks

* start writing about what we talked last time
* after I write something he can give me feedback and point me to new directions
* next meeting on 4.12.2023
* use term bifurcation diagram instead of orbit diagram, if needed define term bifurcation diagram in a way I need

## 15.1.2024

### Tasks

* next meeting on 5.2.2024
* send thesis until 28.1.2024
* next time he will give in depth review of the thesis

## 17.1.2024 (My own notes)

Possible chapter names:

* Introduction
* Theory overview
  * Discrete dynamical systems
  * Logistic map
  * Intermittency
* Intermittency Detection
* Software implementation
* Conclusion
* Appendices


## 5.2.2024 (Meeting with supervisor)

He pointed out several ways to improve the text.
Some of them are these:

* once you define abbreviation object (OBJ) use the shortcut from that moment on in the text
* be careful about whether a fraction should be inline or not. If fraction is in the text write a/b. If it is in an equation write \frac{a}{b}
* don't be afraid of literature, cite more, if you don't read the whole article it's fine
* important definitions and words need to contrast the text - definition in roman where needed or in italics where needed, I found the \emph command for this
* Use the same format for all pseudocodes.
* Use the same format for all the captions of each figure. I decided to follow the format of the article Intermittency Reinjection in The Logistic Map. Describe well what is in the figure. Include parameters. Make captions self standing. Start with capital letter. End with a period.
* Keep consistent throughout the text

## 15.2.2024 (My notes)
Things I could do:

* Benchmarks of the Local Search methods - average time, iterations, f_calls etc.
* Basins of attraction