//
//  geneticAlgorithm.swift
//  MaterialSound
//
//  Created by 董静 on 4/13/21.
//  Copyright © 2021 Doyoung Gwak. All rights reserved.
//

import UIKit
import Foundation

let AVAILABLE_GENES:[Int] = Array(1...1000)
let DNA_LENGTH = 6

let TOURNAMENT_SIZE = 5
let MAX_GENERATIONS_COUNT = 1000

let POPULATION_SIZE = 10000
let MUTATION_CHANCE = 0.1
let SAVE_FITTEST = true

struct Individual: CustomStringConvertible {
    var data:[Int] = [Int](repeating: 0, count: DNA_LENGTH)
    var fitness = 0
    
    mutating func randomize() {
        for index in 0...DNA_LENGTH-1 {
            data[index] = AVAILABLE_GENES[Int(arc4random_uniform(UInt32(AVAILABLE_GENES.count)))]
        }
    }
    
    //Fitnes value should range in 0 to Int max, where 0 is solution equal to OPTIMAL
    mutating func calculateFitness() { //can use reduce
        for index in 0...DNA_LENGTH-1 {
            self.fitness += abs(data[index] - OPTIMAL_SOLUTION!.data[index])
        }
    }
    
    func cross(_ otherIndividual: Individual) -> Individual {
        var individual = Individual()
        
        //DIFFERENT METHODS ARE AVAILABLE:
        //single cross, multi cross, uniform cross (we are using single cross)
        let crossIndex = Int(arc4random_uniform(UInt32(DNA_LENGTH)))
        for i in 0...crossIndex {
            individual.data[i] = self.data[i]
        }
        for i in crossIndex...DNA_LENGTH-1 {
            individual.data[i] = otherIndividual.data[i]
        }
        
        return individual
    }
    
    mutating func mutate() {
        for index in 0...DNA_LENGTH-1 {
            if Double(Float(arc4random()) / Float(UINT32_MAX)) <= MUTATION_CHANCE {
                self.data[index] = AVAILABLE_GENES[Int(arc4random_uniform(UInt32(AVAILABLE_GENES.count)))]
            }
        }
    }
    
    var description : String {
        return "(self.data) Fitness: (self.fitness)"
    }
}

//FRAMEWORK
struct Population {
    var individuals = [Individual]()
    var fittestIndividual: Individual?
    
    mutating func calculateFittestIndividual() {
        fittestIndividual =  individuals.sorted(by: { (first, second) -> Bool in
            first.fitness < second.fitness
        }).first!
    }
}

func runGeneticAlgorithm() {
    
    //Create Initial Population
    var population = createInitialPopulation()
    population.calculateFittestIndividual()

    for generation in 1...MAX_GENERATIONS_COUNT {
        
        var newPopulation = Population()
        if SAVE_FITTEST {
            newPopulation.individuals.append(population.fittestIndividual!)
        }
        
        for _ in newPopulation.individuals.count...POPULATION_SIZE-1 {
            
            //TOURNAMENT METHOD (other is roulette wheel)
            let individual1 = selectParentTournament(population)
            let individual2 = selectParentTournament(population)
            
            var childrenIndividual = individual1.cross(individual2)
            childrenIndividual.mutate()
            childrenIndividual.calculateFitness()
            newPopulation.individuals.append(childrenIndividual)
        }
        
        population = newPopulation
        population.calculateFittestIndividual()
        if population.fittestIndividual!.fitness == 0 {
            print("!!! Generation:(generation) Fittest:(population.fittestIndividual!)")
            break
        }
        print("Generation:(generation) Fittest:(population.fittestIndividual!)")
        print(population.fittestIndividual!.fitness)
    }
}

func selectParentTournament(_ population:Population) -> Individual{
    var tournamentPopulation = Population()
    for _ in 1...TOURNAMENT_SIZE {
       tournamentPopulation.individuals.append(population.individuals[Int(arc4random_uniform(UInt32(population.individuals.count)))])
    }
    tournamentPopulation.calculateFittestIndividual()
    return tournamentPopulation.fittestIndividual!
}

func createInitialPopulation() -> Population{
    var population = Population()
    for _ in 1...POPULATION_SIZE {
        var individual = Individual()
        individual.randomize()
        individual.calculateFitness()
        population.individuals.append(individual)
    }
    return population
}

var OPTIMAL_SOLUTION : Individual?
public func runga() {
    OPTIMAL_SOLUTION = Individual()
    OPTIMAL_SOLUTION!.randomize()
    print("OPTIMAL: (OPTIMAL_SOLUTION.data)")
    runGeneticAlgorithm()
}
