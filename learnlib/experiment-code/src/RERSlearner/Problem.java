package RERSlearner;

import de.learnlib.api.SUL;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;

/**
 * Models a RERS Reachability Problem
 */
public class Problem {
    public int index;
    public long run;
    public Collection<String> inputAlphabet;
    SUL<String,String> sul;

    public Problem (int index, Collection<String> inputAlphabet, long run) {
        this.index = index;
        this.inputAlphabet = inputAlphabet;
        this.run = run;
    }

    public String getRelativeExecutablePath() {
        return "../rers-problems/Problem" + index + "/a.out";
    }

    public String getRelativeResultsPath(BasicLearner.LearningMethod learningMethod, BasicLearner.TestingMethod testingMethod) {
        return "../experiment-results/run-" + run + "/problem" + index + "-" + learningMethod.name().toLowerCase() + "-" + testingMethod.name().toLowerCase() + "/";
    }

    public PrintWriter getLogWriter(BasicLearner.LearningMethod learningMethod, BasicLearner.TestingMethod testingMethod) throws IOException {
        return new PrintWriter(new FileWriter(getRelativeResultsPath(learningMethod, testingMethod) + "log.txt"));
    }

    public SUL<String, String> getSUL() {
        if (this.sul == null) {
            this.sul = new ProcessSUL(getRelativeExecutablePath());
        }
        return this.sul;
    }
}
