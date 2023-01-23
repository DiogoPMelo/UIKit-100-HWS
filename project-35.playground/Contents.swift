import UIKit
import GameplayKit

print(arc4random_uniform(6))

print(GKRandomSource.sharedRandom().nextInt())
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

// high performance and randomness
let arc4 = GKARC4RandomSource()
// discart first 769 values - Apple recommendation
arc4.dropValues(1024)
print(arc4.nextInt(upperBound: 20))

// for maximum randomness
let mersenne = GKMersenneTwisterRandomSource()
print(mersenne.nextInt(upperBound: 20))

// using normal dice
let d6 = GKRandomDistribution.d6()
print(d6.nextInt())

// 20 sided dice
let d20 = GKRandomDistribution.d20()
print(d20.nextInt())

// as many dice sides as needed
let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
print(crazy.nextInt())

// define distributions
let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())

// avoid repetitions
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt(), shuffled.nextInt(), shuffled.nextInt(), shuffled.nextInt(), shuffled.nextInt(), shuffled.nextInt(), separator: ", ")

// normal distribution
let gaussian = GKGaussianDistribution(lowestValue: 1, highestValue: 100)

// random array
let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0...5])

// not so random randoms
let fixedLotteryBalls = [Int](1...49)
for i in 0...3 {
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print("Attempt \(i)")
    print(fixedShuffledBalls[0...5])
}
