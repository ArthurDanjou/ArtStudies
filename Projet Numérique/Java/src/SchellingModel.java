public class SchellingModel {

    private int M;
    private int p;
    private int L;
    private int Ntot;

    public SchellingModel(int M, int p, int L) {
        this.M = M;
        this.p = p;
        this.L = L;
        this.Ntot = L * L;
    }
}
