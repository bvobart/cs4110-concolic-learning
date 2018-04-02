package RERSlearner;

import com.google.common.collect.ImmutableSet;
import de.learnlib.api.SUL;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Jesse Tilro
 */
public class Group16Experiment {
    public static Map<Integer, Problem> problems;

    /**
     * Runs experiments for Group 16's second assignment for the Software Testing and Reverse Engineering course
     * of (2017/18) at Delft University of Technology.
     * @param args
     * @throws IOException
     */
    public static void main(String [] args) throws IOException {
        long run = System.currentTimeMillis() / 1000;

        prepareProblems(run);

        // The TTT RandomWalk experiments took about 15 minutes in total on my machine
        for (int i = 10; i <= 18; i++) {
            try {
                runExperiment(problems.get(i), BasicLearner.LearningMethod.TTT, BasicLearner.TestingMethod.RandomWalk);
            } catch (Exception e) {
                System.out.println("Error occurred in TTT RandomWalk on problem " + i);
                e.printStackTrace();
            }
        }

        // The LStar RandomWalk experiments
        for (int i = 10; i <= 18; i++) {
            try {
                runExperiment(problems.get(i), BasicLearner.LearningMethod.LStar, BasicLearner.TestingMethod.RandomWalk);
            } catch (Exception e) {
                System.out.println("Error occurred in LStar RandomWalk on problem " + i);
                e.printStackTrace();
            }
        }

        // The TTT WMethod experiments
        runExperiment(problems.get(10), BasicLearner.LearningMethod.TTT, BasicLearner.TestingMethod.WMethod);
        runExperiment(problems.get(14), BasicLearner.LearningMethod.TTT, BasicLearner.TestingMethod.WMethod);

        // The LStar WMethod experiments
//        runExperiment(problems.get(10), BasicLearner.LearningMethod.LStar, BasicLearner.TestingMethod.WMethod);
        runExperiment(problems.get(14), BasicLearner.LearningMethod.LStar, BasicLearner.TestingMethod.WMethod);
    }

    public static void runExperiment(Problem problem, BasicLearner.LearningMethod learningMethod, BasicLearner.TestingMethod testingMethod) throws IOException {
        // the input alphabet
        Collection<String> inputAlphabet = ImmutableSet.of("1","2","3","4","5");

        try {
            // runControlledExperiment for detailed statistics, runSimpleExperiment for just the result
            //BasicLearner.runControlledExperiment(sul, BasicLearner.LearningMethod.TTT, BasicLearner.TestingMethod.RandomWalk, inputAlphabet);
            BasicLearner.runControlledExperiment(problem, learningMethod, testingMethod, problem.inputAlphabet);
        } finally {
            if (problem.getSUL() instanceof AutoCloseable) {
                try {
                    ((AutoCloseable) problem.getSUL()).close();
                } catch (Exception exception) {
                    // should not happen
                }
            }
        }
    }

    /**
     * Build data structure indexing the available problem programs for which an automaton can be learned.
     */
    private static void prepareProblems(long run) {
        Collection<String> alphabetFive = ImmutableSet.of("1","2","3","4","5");
        Collection<String> alphabetTen = ImmutableSet.of("1","2","3","4","5", "6", "7", "8", "9", "10");
        Collection<String> alphabetFifteen = ImmutableSet.of("1","2","3","4","5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15");
        Collection<String> alphabetTwenty = ImmutableSet.of("1","2","3","4","5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20");

        problems = new HashMap<Integer, Problem>();
        problems.put(10, new Problem(10, alphabetFive, run));
        problems.put(11, new Problem(11, alphabetTen, run));
        problems.put(12, new Problem(12, alphabetFifteen, run));
        problems.put(13, new Problem(13, alphabetTen, run));
        problems.put(14, new Problem(14, alphabetFifteen, run));
        problems.put(15, new Problem(15, alphabetFifteen, run));
        problems.put(16, new Problem(16, alphabetTen, run));
        problems.put(17, new Problem(17, alphabetFifteen, run));
        problems.put(18, new Problem(18, alphabetTwenty, run));
    }
}