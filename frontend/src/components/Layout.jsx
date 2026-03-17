import Sidebar from './Sidebar';

export default function Layout({ children }) {
  return (
    <div style={{ display: 'flex' }}>
      <Sidebar />
      <main style={styles.main}>
        {children}
      </main>
    </div>
  );
}

const styles = {
  main: {
    marginLeft: 240, flex: 1, minHeight: '100vh',
    background: '#f3f4f6', padding: 24,
  },
};