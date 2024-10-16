class Solution:
    def findCriticalAndPseudoCriticalEdges(self, n, edges):
        def u(x,i,j):return x.replace(x[i],x[j])
        edges = sorted([(w,u,v,i)for i, (u,v,w) in enumerate(edges)])
        ans1, ans2 = [], []

        for w1,u1,v1,i in edges:
            x1, x2 = ''.join(map(chr,range(100))), ''.join(map(chr,range(100)))
            x1=x1.replace(x1[u1],x1[v1])
            t1, t2 = w1, 0
            for w2,u2,v2,j in edges:
                if i == j: continue
                t1+=w2*(x1[u2]!=x1[v2])
                x1=u(x1,u2,v2)
                t2+=w2*(x2[u2]!=x2[v2])
                x2=u(x2,u2,v2)

            if t1 == t2:
                ans1.append(i)
            elif t1 < t2 or x2[u1]!=x2[v1]:
                x2=u(x2,u1,v1)
                ans2.append(i)

        return ans2, ans1



from Solution import Solution

def main():
    n=3
    edges = [(1, 0, 1), (2, 0, 2), (3, 1, 2)]
    sol= Solution()
    critical_edges, pseudo_critical_edges = sol.findCriticalAndPseudoCriticalEdges(n, edges)
    print("Critical edges", critical_edges)
    print("Pseudo-crtical edges", pseudo_critical_edges)
if __name__ == "__main__":
    main()